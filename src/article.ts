import {
  array,
  decodeType,
  field,
  number,
  optional,
  record,
  string,
} from "typescript-json-decoder";

export type Article = decodeType<typeof decodeArticle>;

export const decodeArticle = record({
  title: string,
  author: string,
  category: optional(string),
  date: string,
  coverPhoto: field("cover-photo", optional(string)),
  perex: string,
  serial: optional(string),
  relativeURL: string,
  tags: array(string),
  numberOfWords: number,
});
