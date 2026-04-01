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
    <div className="shell">
      <header className="topbar">
        <h1 className="topbar-title">Demographics</h1>
        <span className="topbar-badge">Ed-Fi ODS</span>
      </header>
      <main>
        <SchoolSelector data={rows} />
      </main>
    </div>
  )
}
