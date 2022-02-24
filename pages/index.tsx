import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { loadAllArticles } from "src/site-data";
import FilterSidebar from "src/FilterSidebar";
import { useEffect, useState } from "react";
import { useRouter } from "next/router";
import {
  deserializeSettings,
  FilterOptions,
  getFilterOptions,
  match,
  serializeSettings,
  Settings,
} from "src/filters";

interface Props {
  articles: Article[];
  filterOptions: FilterOptions;
}

const Home: NextPage<Props> = (props) => {
  const { articles, filterOptions } = props;

  const hash = typeof window !== "undefined" ? window.location.hash : "";
  const initialSettings = deserializeSettings(hash);

  const [settings, setSettings] = useState(initialSettings);
  const [matchingArticles, setMatchingArticles] = useState(articles);

  useEffect(() => {
    const matches = articles.filter((a) => match(a, settings));
    setMatchingArticles(matches);
  }, [settings, articles]);

  const router = useRouter();
  const updateUrl = (settings: Settings) =>
    router.replace("#" + serializeSettings(settings));

  const updateFilters = (id: string, newValue: string | undefined) => {
    if (newValue) {
      const newSettings = { ...settings, [id]: newValue };
      setSettings(newSettings);
      updateUrl(newSettings);
    } else {
      const { [id]: _, ...newSettings } = settings;
      setSettings(newSettings);
      updateUrl(newSettings);
    }
  };

  const removeAllFilters = () => {
    setSettings({});
    updateUrl({});
  };

  return (
    <div>
      <Header />
      <div className="status">
        nalezených článků: {matchingArticles.length}/{articles.length}
      </div>
      <FilterSidebar
        options={filterOptions}
        settings={settings}
        onChange={updateFilters}
        removeAllFilters={removeAllFilters}
      />
      <Results articles={matchingArticles} />
    </div>
  );
};

const Header: React.FC = () => {
  return (
    <div className="header">
      <h1>
        Ohlasy <small>archiv článků</small>
      </h1>
    </div>
  );
};

const Results: React.FC<{ articles: Article[] }> = ({ articles }) => {
  return (
    <div className="articles">
      {articles.map((article) => (
        <ArticleBox key={article.relativeURL} {...article} />
      ))}
    </div>
  );
};

const ArticleBox: React.FC<Article> = (article) => {
  const fmtDate = (d: string) =>
    new Date(d).toLocaleDateString("cs-CZ", { dateStyle: "medium" });
  return (
    <a href={"https://ohlasy.info" + article.relativeURL}>
      <div className="article-wrapper">
        <div className="article">
          <h2>{article.title}</h2>
          <div className="metadata">
            <span className="author">{article.author}</span>
            {" / "}
            <span className="pubDate">{fmtDate(article.pubDate)}</span>
          </div>
          <p className="perex">{article.perex}</p>
        </div>
      </div>
    </a>
  );
};

export const getStaticProps: GetStaticProps<Props> = async () => {
  const articles = await loadAllArticles();
  const filterOptions = getFilterOptions(articles);
  return {
    props: {
      articles,
      filterOptions,
    },
  };
};
export default Home;
