import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { loadAllArticles } from "src/site-data";
import { useRouter } from "next/router";
import { buildSearchUrl } from "src/utils";
import MainPage from "components/MainPage";
import {
  deserializeSettings,
  buildFilterOptions,
  serializeSettings,
  Settings,
} from "src/filters";

interface Props {
  articles: Article[];
}

const Home: NextPage<Props> = (props) => {
  const { articles } = props;

  // Gather available filter values
  const filterOptions = buildFilterOptions(articles);

  // Load initial settings from URL
  const hash = typeof window !== "undefined" ? window.location.hash : "";
  const initialSettings = deserializeSettings(hash);

  // Save every settings change back to the URL
  const router = useRouter();
  const updateUrl = (settings: Settings) =>
    router.replace("#" + serializeSettings(settings));

  // Search navigates away to Google
  const triggerSearch = (query: string) => router.push(buildSearchUrl(query));

  return (
    <MainPage
      allArticles={articles}
      filterOptions={filterOptions}
      initialSettings={initialSettings}
      onSettingsChange={updateUrl}
      triggerSearch={triggerSearch}
    />
  );
};

export const getStaticProps: GetStaticProps<Props> = async () => {
  const articles = await loadAllArticles();
  return {
    props: { articles },
  };
};
export default Home;
