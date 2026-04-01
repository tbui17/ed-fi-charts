"use client"

import { DemographicRow, DemographicType, DEMOGRAPHIC_LABELS } from "../lib/types"

const COHORT_COLORS = [
  "var(--cohort-1)",
  "var(--cohort-2)",
  "var(--cohort-3)",
  "var(--cohort-4)",
  "var(--cohort-5)",
  "var(--cohort-6)",
  "var(--cohort-7)",
  "var(--cohort-8)",
  "var(--cohort-9)",
  "var(--cohort-10)",
]

const MAX_BAR_SEGMENTS = 5

const VALUE_LABELS: Record<string, Record<string, string>> = {
  hispanic_or_latino: {
    true: "Hispanic or Latino",
    false: "Not Hispanic or Latino",
  },
}

function displayValue(type: string, value: string): string {
  return VALUE_LABELS[type]?.[value] ?? value
}

export function DemographicsChart({ data }: { data: DemographicRow[] }) {
  const types = [...new Set(data.map((r) => r.type))] as DemographicType[]

  if (types.length === 0) {
    return <p className="empty">No demographic data available.</p>
  }

  return (
    <div className="categories">
      {types.map((type) => {
        const rows = data
          .filter((r) => r.type === type)
          .sort((a, b) => Number(b.count) - Number(a.count))
        const total = rows.reduce((sum, r) => sum + Number(r.count), 0)

        const topRows = rows.slice(0, MAX_BAR_SEGMENTS)
        const restRows = rows.slice(MAX_BAR_SEGMENTS)
        const restCount = restRows.reduce((sum, r) => sum + Number(r.count), 0)

        return (
          <div key={type} className="category">
            <div className="category-header">
              <h3 className="category-title">
                {DEMOGRAPHIC_LABELS[type] ?? type}
              </h3>
              <span className="category-total">
                {total.toLocaleString()}
              </span>
            </div>

            <div className={`proportion-bar${total < 20 ? " proportion-bar--thin" : ""}`}>
              {topRows.map((row, i) => {
                const pct = total > 0 ? (Number(row.count) / total) * 100 : 0
                if (pct === 0) return null
                return (
                  <div
                    key={row.value}
                    className="proportion-segment"
                    style={{
                      width: `${pct}%`,
                      backgroundColor: COHORT_COLORS[i],
                    }}
                    title={`${displayValue(type, row.value)}: ${Number(row.count).toLocaleString()} (${pct.toFixed(1)}%)`}
                  />
                )
              })}
              {restCount > 0 && (
                <div
                  className="proportion-segment"
                  style={{
                    width: `${(restCount / total) * 100}%`,
                    backgroundColor: "var(--cohort-other)",
                  }}
                  title={`Remaining: ${restCount.toLocaleString()} (${((restCount / total) * 100).toFixed(1)}%)`}
                />
              )}
            </div>

            <div className="legend">
              {topRows.map((row, i) => {
                const pct = total > 0 ? (Number(row.count) / total) * 100 : 0
                return (
                  <div key={row.value} className="legend-item">
                    <span
                      className="legend-swatch"
                      style={{ backgroundColor: COHORT_COLORS[i] }}
                    />
                    <span className="legend-label">{displayValue(type, row.value)}</span>
                    <span className="legend-pct">{pct.toFixed(1)}%</span>
                    <span className="legend-count">
                      {Number(row.count).toLocaleString()}
                    </span>
                  </div>
                )
              })}
              {restCount > 0 && (
                <div className="legend-item">
                  <span
                    className="legend-swatch"
                    style={{ backgroundColor: "var(--cohort-other)" }}
                  />
                  <span className="legend-label">Remaining ({restRows.length})</span>
                  <span className="legend-pct">
                    {((restCount / total) * 100).toFixed(1)}%
                  </span>
                  <span className="legend-count">
                    {restCount.toLocaleString()}
                  </span>
                </div>
              )}
            </div>

            {restRows.length > 0 && (
              <div className="legend-overflow">
                {restRows.map((row) => {
                  const pct = total > 0 ? (Number(row.count) / total) * 100 : 0
                  return (
                    <div key={row.value} className="legend-overflow-item">
                      <span className="legend-label">{displayValue(type, row.value)}</span>
                      <span className="legend-pct">{pct.toFixed(1)}%</span>
                      <span className="legend-count">
                        {Number(row.count).toLocaleString()}
                      </span>
                    </div>
                  )
                })}
              </div>
            )}
          </div>
        )
      })}
    </div>
  )
}
