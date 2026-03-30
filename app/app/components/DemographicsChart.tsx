"use client"

import {
  Chart as ChartJS,
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Legend,
  Tooltip,
  Colors,
} from "chart.js"
import { Bar } from "react-chartjs-2"
import { useState } from "react"
import { DemographicRow, DemographicType, DEMOGRAPHIC_LABELS } from "../lib/types"

ChartJS.register(
  BarController,
  BarElement,
  CategoryScale,
  LinearScale,
  Legend,
  Tooltip,
  Colors
)

const COLORS = [
  "#4e79a7", "#f28e2b", "#e15759", "#76b7b2",
  "#59a14f", "#edc948", "#b07aa1", "#ff9da7",
  "#9c755f", "#bab0ac",
]

export function DemographicsChart({ data }: { data: DemographicRow[] }) {
  const [mode, setMode] = useState<"count" | "percent">("count")

  const types = [...new Set(data.map((r) => r.type))] as DemographicType[]

  return (
    <div>
      <div style={{ marginBottom: "1rem" }}>
        <button
          onClick={() => setMode("count")}
          style={{ fontWeight: mode === "count" ? "bold" : "normal", marginRight: "0.5rem" }}
        >
          Count
        </button>
        <button
          onClick={() => setMode("percent")}
          style={{ fontWeight: mode === "percent" ? "bold" : "normal" }}
        >
          Percentage
        </button>
      </div>

      <div
        style={{
          display: "grid",
          gridTemplateColumns: "repeat(auto-fit, minmax(400px, 1fr))",
          gap: "2rem",
        }}
      >
        {types.map((type) => {
          const rows = data.filter((r) => r.type === type)
          const labels = rows.map((r) => r.value)
          const values = rows.map((r) =>
            mode === "percent" ? +(r.percent * 100).toFixed(1) : Number(r.count)
          )

          return (
            <div key={type}>
              <h3>{DEMOGRAPHIC_LABELS[type] ?? type}</h3>
              <Bar
                data={{
                  labels,
                  datasets: [
                    {
                      label: mode === "percent" ? "%" : "Count",
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
                    legend: { display: false },
                    tooltip: {
                      callbacks: {
                        label: (ctx) =>
                          mode === "percent"
                            ? `${ctx.parsed.y}%`
                            : `${ctx.parsed.y}`,
                      },
                    },
                  },
                  scales: {
                    y: {
                      beginAtZero: true,
                      title: {
                        display: true,
                        text: mode === "percent" ? "Percentage" : "Count",
                      },
                    },
                  },
                }}
              />
            </div>
          )
        })}
      </div>
    </div>
  )
}
