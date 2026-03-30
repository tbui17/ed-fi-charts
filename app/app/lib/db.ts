import { Kysely, PostgresDialect } from "kysely"
import { Pool } from "pg"

interface VDemographics {
  district_name: string
  school_name: string
  type: string
  value: string
  count: number
  percent: number
}

interface Database {
  "warehouse.v_demographics": VDemographics
}

export const db = new Kysely<Database>({
  dialect: new PostgresDialect({
    pool: new Pool({
      connectionString: process.env.DATABASE_URL,
    }),
  }),
})
