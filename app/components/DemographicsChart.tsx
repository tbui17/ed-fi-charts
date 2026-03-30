"use client"

import {
  Chart as ChartJS,
  ArcElement,
  Legend,
  Tooltip,
} from "chart.js"
import { Pie } from "react-chartjs-2"
import { DemographicRow, DemographicType, DEMOGRAPHIC_LABELS } from "../lib/types"

ChartJS.register(ArcElement, Legend, Tooltip)

const COLORS = [
  "#4e79a7", "#f28e2b", "#e15759", "#76b7b2",
  "#59a14f", "#edc948", "#b07aa1", "#ff9da7",
  "#9c755f", "#bab0ac",
]

export function DemographicsChart({ data }: { data: DemographicRow[] }) {
  const types = [...new Set(data.map((r) => r.type))] as DemographicType[]

  return (
    <div
      style={{
        display: "grid",
        gridTemplateColumns: "repeat(auto-fit, minmax(350px, 1fr))",
        gap: "2rem",
      }}
    >
      {types.map((type) => {
        const rows = data.filter((r) => r.type === type)
        const labels = rows.map((r) => r.value)
        const values = rows.map((r) => Number(r.count))

        return (
          <div key={type}>
            <h3>{DEMOGRAPHIC_LABELS[type] ?? type}</h3>
            <Pie
              data={{
                labels,
                datasets: [
                  {
                    data: values,
                    backgroundColor: labels.map(
                      (_, i) => COLORS[i % COLORS.length]
                    ),
                  },
                ],
              }}
              options={{
                responsive: true,
                plugins: {
                  legend: { position: "bottom" },
                  tooltip: {
                    callbacks: {
                      label: (ctx) => {
                        const total = ctx.dataset.data.reduce(
                          (a: number, b: number) => a + b,
                          0
                        )
                        const pct = ((ctx.parsed / total) * 100).toFixed(1)
                        return `${ctx.label}: ${ctx.parsed} (${pct}%)`
                      },
                    },
                  },
                },
              }}
            />
          </div>
        )
      })}
    </div>
  )
}
