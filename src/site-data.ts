import { Article, decodeArticle } from "./article";
import fetch from "node-fetch";
import { filterUndefines } from "./utils";

export async function loadAllArticles(): Promise<Article[]> {
  const response = await fetch("https://ohlasy.info/api/articles");
  const json = await response.json();
  if (!Array.isArray(json)) {
    throw `Expected article list to be an array, got ${typeof json} instead.`;
  }
  return filterUndefines(json.map(decodeArticle));
}
