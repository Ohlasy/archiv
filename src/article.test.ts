import { Article, decodeArticle } from "./article";

test("Decode article", () => {
  expect(
    decodeArticle({
      "title": "Každý má svůj příběh: Jiří Rožek – Cti otce svého i matku svou",
      "author": "Ladislav Oujeský",
      "category": "seriály",
      "pubDate": "2022-02-04 00:00:00 +0000",
      "cover-photo": "https://i.ohlasy.info/i/20bc35d0.jpg",
      "perex":
        "Většina obyvatel Boskovic zná pana Jiřího Rožka jako obětavého veterináře, který se velkou část svého života staral o všechny němé tváře z blízkého okolí. Málokdo tuší, co prožíval jako malý kluk v 50. letech, když mu odsoudili otce a on musel se svými sourozenci a nevlastní matkou opustit ze dne na den rodný dům.\n",
      "serial": "pribehy",
      "relativeURL": "/clanky/2022/02/pribeh-jiriho-rozka.html",
      "tags": [],
      "numberOfWords": 800,
    })
  ).toEqual<Article>({
    title: "Každý má svůj příběh: Jiří Rožek – Cti otce svého i matku svou",
    author: "Ladislav Oujeský",
    category: "seriály",
    pubDate: "2022-02-04T00:00:00Z",
    coverPhoto: "https://i.ohlasy.info/i/20bc35d0.jpg",
    perex:
      "Většina obyvatel Boskovic zná pana Jiřího Rožka jako obětavého veterináře, který se velkou část svého života staral o všechny němé tváře z blízkého okolí. Málokdo tuší, co prožíval jako malý kluk v 50. letech, když mu odsoudili otce a on musel se svými sourozenci a nevlastní matkou opustit ze dne na den rodný dům.\n",
    serial: "pribehy",
    relativeURL: "/clanky/2022/02/pribeh-jiriho-rozka.html",
    tags: [],
    numberOfWords: 800,
  });
});
