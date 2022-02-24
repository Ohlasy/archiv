import { Article } from "./article";
import { unique } from "./utils";

export type FilterOptions = Record<string, string[]>;
export type Settings = Record<string, string>;

export interface Filter {
  id: string;
  name: string;
  extractPossibleValues: (article: Article) => string[];
  match: (article: Article, value: string) => boolean;
  displayValue?: (value: string) => string;
}

export const filters: Filter[] = [
  {
    id: "autor",
    name: "Autor",
    extractPossibleValues: (article) => [article.author],
    match: (article, value) => article.author === value,
  },
  {
    id: "rubrika",
    name: "Rubrika",
    extractPossibleValues: ({ category }) => (category ? [category] : []),
    match: (article, value) => article.category === value,
  },
  {
    id: "serial",
    name: "Seriál",
    extractPossibleValues: ({ serial }) => (serial ? [serial] : []),
    match: (article, value) => article.serial === value,
    displayValue: (serialId: string) => {
      const names: any = {
        pribehy: "Každý má svůj příběh",
        krajiny: "Krajiny Boskovicka",
        ghetto: "Příběhy z ghetta",
        prochazky: "Procházky po památkách",
        jazyk: "Rendez-vous s jazykem",
        depozitar: "Z muzejního depozitáře",
        osmicky: "Osmičková výročí",
        stromy: "Život pod stromy",
        historie: "Pohledy do historie",
      };
      return names[serialId] || serialId;
    },
  },
  {
    id: "tag",
    name: "Téma",
    extractPossibleValues: ({ tags }) => tags,
    match: (article, value) => article.tags.includes(value),
  },
  {
    id: "rok",
    name: "Rok",
    extractPossibleValues: (article) => [getYear(article)],
    match: (article, value) => getYear(article) === value,
  },
];

export function getFilterOptions(articles: Article[]): FilterOptions {
  const getPossibleValues = (f: Filter) =>
    unique(articles.map(f.extractPossibleValues).flat());
  const filtersAndValues = filters.map((filter) => [
    filter.id,
    getPossibleValues(filter),
  ]);
  return Object.fromEntries(filtersAndValues);
}

export function match(article: Article, settings: Settings): boolean {
  for (const [filterId, wantedValue] of Object.entries(settings)) {
    const filter = filters.find((f) => f.id === filterId);
    if (!filter) {
      console.warn(`Unknown filter id “${filterId}” in settings, skipping.`);
      continue;
    }
    if (!filter.match(article, wantedValue)) {
      return false;
    }
  }
  return true;
}

export function serializeSettings(settings: Settings): string {
  return Object.entries(settings)
    .map(([key, val]) => `${key}=${val}`)
    .join("&");
}

export function deserializeSettings(hash: string): Settings {
  return Object.fromEntries(
    hash
      .replace("#", "")
      .split("&")
      .map((part) => part.split("=").map(decodeURIComponent))
  );
}

const getYear = (a: Article) => new Date(a.pubDate).getFullYear().toString();
