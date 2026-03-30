import { db } from "./lib/db"
import { DemographicRow } from "./lib/types"
import { SchoolSelector } from "./components/SchoolSelector"

export const dynamic = "force-dynamic"

export default async function Page() {
  const rows = (await db
    .selectFrom("warehouse.v_demographics" as any)
    .selectAll()
    .execute()) as DemographicRow[]

  return (
    <div style={{ maxWidth: 1200, margin: "0 auto", padding: "2rem" }}>
      <h1>Ed-Fi Demographics Dashboard</h1>
      <p style={{ color: "#666", marginBottom: "2rem" }}>
        Enrollment demographics by school from the Ed-Fi ODS warehouse
      </p>
      <SchoolSelector data={rows} />
    </div>
  )
}
