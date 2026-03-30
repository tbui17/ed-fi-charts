process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0";

import axios from "axios";
import { readFileSync, writeFileSync, existsSync } from "node:fs";
import { Api } from "./ed-fi-api";
import * as R from "remeda";

const TOKEN_FILE = "./token.json";
const BASE_URL = "https://localhost/api";
const CLIENT_ID = "populated";
const CLIENT_SECRET = "populatedSecret";
const OUTPUT_FILE = "./output.json";

interface TokenData {
    access_token: string;
    expires_at: number;
}

async function getToken(): Promise<string> {
    if (existsSync(TOKEN_FILE)) {
        const cached: TokenData = JSON.parse(readFileSync(TOKEN_FILE, "utf-8"));
        if (cached.expires_at > Date.now()) {
            return cached.access_token;
        }
    }

    const res = await axios.post(
        `${BASE_URL}/oauth/token`,
        `grant_type=client_credentials&client_id=${CLIENT_ID}&client_secret=${CLIENT_SECRET}`,
    );

    const tokenData: TokenData = {
        access_token: res.data.access_token,
        expires_at: Date.now() + res.data.expires_in * 1000 - 30_000,
    };
    writeFileSync(TOKEN_FILE, JSON.stringify(tokenData, null, 2));
    return tokenData.access_token;
}

const token = await getToken();

const client = new Api({
    baseURL: `${BASE_URL}/data/v3`,
    securityWorker: () => ({
        headers: { Authorization: `Bearer ${token}` },
    }),
    secure: true,
});

async function getStudentSchools(studentUniqueId: string) {
    return R.pipe(
        await client.edFi.getStudentSchoolAssociations({ studentUniqueId }).then((x) => x.data),
        R.map((x) => client.edFi.getSchools({ schoolId: x.schoolReference.schoolId })),
        (promises) => Promise.all(promises),
        async (x) =>
            R.pipe(
                await x,
                R.flatMap((r) => r.data),
                R.map((s) => s.nameOfInstitution),
            ),
    );
}

async function getSchoolStudents(schoolId: number) {
    return R.pipe(
        await client.edFi.getStudentSchoolAssociations({ schoolId }).then((x) => x.data),
        R.map((x) => client.edFi.getStudents({ studentUniqueId: x.studentReference.studentUniqueId })),
        (promises) => Promise.all(promises),
        async (x) =>
            R.pipe(
                await x,
                R.flatMap((r) => r.data),
                R.map((s) => `${s.firstName} ${s.lastSurname}`),
            ),
    );
}

async function getSchoolsAndStudents() {
    return R.pipe(
        await client.edFi.getSchools().then((x) => x.data),
        R.map(async (school) => ({
            schoolName: school.nameOfInstitution,
            students: await getSchoolStudents(school.schoolId),
        })),
        (promises) => Promise.all(promises),
    );
}

R.pipe(
  await getSchoolsAndStudents(),
  console.log
);

