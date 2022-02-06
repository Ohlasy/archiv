import {
  array,
  decodeType,
  field,
  nullable,
  number,
  Pojo,
  record,
  string,
} from "typescript-json-decoder";

export type Article = decodeType<typeof decodeArticle>;

export const decodeArticle = record({
  title: string,
  author: string,
  category: nullable(string),
  pubDate: date,
  coverPhoto: field("cover-photo", nullable(string)),
  perex: string,
  serial: nullable(string),
  relativeURL: string,
  tags: array(string),
  numberOfWords: number,
});

function date(value: Pojo): string {
  return string(value).replace(" +0000", "Z").replace(" ", "T");
}
