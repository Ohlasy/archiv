import {
  array,
  decodeType,
  field,
  nullable,
  number,
  record,
  string,
} from "typescript-json-decoder";

export type Article = decodeType<typeof decodeArticle>;

export const decodeArticle = record({
  title: string,
  author: string,
  category: nullable(string),
  pubDate: string,
  coverPhoto: field("cover-photo", nullable(string)),
  perex: string,
  serial: nullable(string),
  relativeURL: string,
  tags: array(string),
  numberOfWords: number,
});
