"use client"

import { useState, useMemo } from "react"
import { DemographicRow } from "../lib/types"
import { DemographicsChart } from "./DemographicsChart"

export function SchoolSelector({ data }: { data: DemographicRow[] }) {
  const districts = useMemo(
    () => [...new Set(data.map((r) => r.district_name))].sort(),
    [data]
  )

  const [selectedDistrict, setSelectedDistrict] = useState(districts[0] ?? "")

  const schoolsInDistrict = useMemo(
    () =>
      [
        ...new Set(
          data
            .filter((r) => r.district_name === selectedDistrict)
            .map((r) => r.school_name)
        ),
      ].sort(),
    [data, selectedDistrict]
  )

  const [selectedSchool, setSelectedSchool] = useState(
    schoolsInDistrict[0] ?? ""
  )

  const filteredData = useMemo(
    () =>
      data.filter(
        (r) =>
          r.district_name === selectedDistrict &&
          r.school_name === selectedSchool
      ),
    [data, selectedDistrict, selectedSchool]
  )

  return (
    <div>
      <div style={{ display: "flex", gap: "1rem", marginBottom: "2rem" }}>
        <label>
          District:{" "}
          <select
            value={selectedDistrict}
            onChange={(e) => {
              setSelectedDistrict(e.target.value)
              const schools = [
                ...new Set(
                  data
                    .filter((r) => r.district_name === e.target.value)
                    .map((r) => r.school_name)
                ),
              ].sort()
              setSelectedSchool(schools[0] ?? "")
            }}
          >
            {districts.map((d) => (
              <option key={d} value={d}>
                {d}
              </option>
            ))}
          </select>
        </label>

        <label>
          School:{" "}
          <select
            value={selectedSchool}
            onChange={(e) => setSelectedSchool(e.target.value)}
          >
            {schoolsInDistrict.map((s) => (
              <option key={s} value={s}>
                {s}
              </option>
            ))}
          </select>
        </label>
      </div>

      <DemographicsChart data={filteredData} />
    </div>
  )
}
