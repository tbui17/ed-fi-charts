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

  const totalEnrolled = useMemo(() => {
    const firstType = filteredData[0]?.type
    if (!firstType) return 0
    return filteredData
      .filter((r) => r.type === firstType)
      .reduce((sum, r) => sum + Number(r.count), 0)
  }, [filteredData])

  return (
    <>
      <div className="toolbar">
        <div className="field">
          <span className="field-label">District</span>
          <div className="select-wrap">
            <select
              className="select"
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
            <svg className="select-chevron" viewBox="0 0 16 16" fill="none">
              <path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
        </div>

        <div className="field">
          <span className="field-label">School</span>
          <div className="select-wrap">
            <select
              className="select"
              value={selectedSchool}
              onChange={(e) => setSelectedSchool(e.target.value)}
            >
              {schoolsInDistrict.map((s) => (
                <option key={s} value={s}>
                  {s}
                </option>
              ))}
            </select>
            <svg className="select-chevron" viewBox="0 0 16 16" fill="none">
              <path d="M4 6l4 4 4-4" stroke="currentColor" strokeWidth="1.5" strokeLinecap="round" strokeLinejoin="round"/>
            </svg>
          </div>
        </div>

        <div className="toolbar-stat">
          <span className="stat-value">{totalEnrolled.toLocaleString()}</span>
          <span className="stat-label">Enrolled</span>
        </div>
      </div>

      <DemographicsChart data={filteredData} />
    </>
  )
}
