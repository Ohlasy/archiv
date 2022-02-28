import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { loadAllArticles } from "src/site-data";
import { useRouter } from "next/router";
import { buildSearchUrl } from "src/utils";
import MainPage from "components/MainPage";
import { buildFilterOptions, Settings } from "src/filters";
import Head from "next/head";

interface Props {
  articles: Article[];
}

const Home: NextPage<Props> = (props) => {
  const { articles } = props;
  const router = useRouter();

  // Gather available filter values
  const filterOptions = buildFilterOptions(articles);

  // Load initial settings from URL
  const initialSettings = router.query as Settings;

  // Save every settings change back to the URL
  const updateUrl = (settings: Settings) =>
    router.replace("/?" + new URLSearchParams(settings));

  // Search navigates away to Google
  const triggerSearch = (query: string) => router.push(buildSearchUrl(query));

  return (
    <>
      <Head>
        <title>Archiv článků | Ohlasy</title>
        <meta
          property="og:image"
          content="https://i.ohlasy.info/i/0037315a.jpg"
        />
        <meta
          property="og:description"
          content="Archiv všech doposud vydaných článků. Filtrujte podle autora, rubriky nebo seriálu."
        />
        <link rel="shortcut icon" type="image/png" href="/favicon.png" />
      </Head>
      <MainPage
        allArticles={articles}
        filterOptions={filterOptions}
        initialSettings={initialSettings}
        onSettingsChange={updateUrl}
        triggerSearch={triggerSearch}
      />
    </>
  );
};

export const getStaticProps: GetStaticProps<Props> = async () => {
  const articles = await loadAllArticles();
  return {
    props: { articles },
    revalidate: 60 * 60, // update each hour
  };
};
export default Home;
