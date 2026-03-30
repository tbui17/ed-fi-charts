export interface DemographicRow {
  district_name: string
  school_name: string
  type: string
  value: string
  count: number
  percent: number
}

export type DemographicType =
  | "sex"
  | "race"
  | "disability"
  | "language"
  | "tribal"
  | "lep_status"
  | "hispanic_or_latino"

export const DEMOGRAPHIC_LABELS: Record<DemographicType, string> = {
  sex: "Sex",
  race: "Race",
  disability: "Disability",
  language: "Language",
  tribal: "Tribal Affiliation",
  lep_status: "LEP Status",
  hispanic_or_latino: "Hispanic/Latino",
}
