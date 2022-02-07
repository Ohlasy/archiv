import { Article } from "./article";
import { filterMap, unique } from "./utils";

export interface Filters {
  author?: string;
}

export interface FilterOptions {
  authors: string[];
  categories: string[];
  serials: string[];
  topics: string[];
  years: string[];
}

export function getFilterOptions(articles: Article[]): FilterOptions {
  return {
    authors: unique(articles.map((a) => a.author)),
    categories: unique(filterMap(articles, (a) => a.category)),
    serials: unique(filterMap(articles, (a) => a.serial)),
    topics: unique(articles.flatMap((a) => a.tags)),
    years: unique(articles.map(getYear)),
  };
}

const getYear = (a: Article) => new Date(a.pubDate).getFullYear().toString();
