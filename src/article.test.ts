import { Article, decodeArticle } from "./article";

test("Decode article", () => {
  expect(
    decodeArticle({
      "title": "Každý má svůj příběh: Jiří Rožek – Cti otce svého i matku svou",
      "author": "Ladislav Oujeský",
      "category": "seriály",
      "date": "Wed Dec 14 2022 00:00:00 GMT+0000 (Coordinated Universal Time)",
      "cover-photo":
        "/api/resize?src=https://i.ohlasy.info/i/8ee9ff77.jpg&width=640&proof=6bfb2837501fffffe2a21ddc4f2546c7a4207cdd",
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
    date: "Wed Dec 14 2022 00:00:00 GMT+0000 (Coordinated Universal Time)",
    coverPhoto:
      "/api/resize?src=https://i.ohlasy.info/i/8ee9ff77.jpg&width=640&proof=6bfb2837501fffffe2a21ddc4f2546c7a4207cdd",
    perex:
      "Většina obyvatel Boskovic zná pana Jiřího Rožka jako obětavého veterináře, který se velkou část svého života staral o všechny němé tváře z blízkého okolí. Málokdo tuší, co prožíval jako malý kluk v 50. letech, když mu odsoudili otce a on musel se svými sourozenci a nevlastní matkou opustit ze dne na den rodný dům.\n",
    serial: "pribehy",
    relativeURL: "/clanky/2022/02/pribeh-jiriho-rozka.html",
    tags: [],
    numberOfWords: 800,
  });
});
