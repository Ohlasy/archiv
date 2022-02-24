import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { FilterOptions, getFilterOptions, match } from "src/filters";
import { loadAllArticles } from "src/site-data";
import FilterSidebar from "src/FilterSidebar";
import { useEffect, useState } from "react";

type Settings = Record<string, string>;

interface Props {
  articles: Article[];
  filterOptions: FilterOptions;
}

const Home: NextPage<Props> = (props) => {
  const { articles, filterOptions } = props;
  const [settings, setSettings] = useState<Settings>({});
  const [matchingArticles, setMatchingArticles] = useState(articles);

  useEffect(() => {
    const matches = articles.filter((a) => match(a, settings));
    setMatchingArticles(matches);
  }, [settings, articles]);

  const updateFilters = (id: string, newValue: string | undefined) => {
    if (newValue) {
      setSettings({ ...settings, [id]: newValue });
    } else {
      const newSettings = settings;
      delete newSettings[id];
      setSettings(newSettings);
    }
    console.log(settings);
  };

  return (
    <div>
      <Header />
      <Stats articles={matchingArticles} />
      <FilterSidebar options={filterOptions} onChange={updateFilters} />
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

const Stats: React.FC<{ articles: Article[] }> = ({ articles }) => {
  return <div className="status">nalezených článků: {articles.length}</div>;
};

const Results: React.FC<{ articles: Article[] }> = ({ articles }) => {
  return (
    <div className="articles">
      {articles.map((article, index) => (
        <ArticleBox key={index} {...article} />
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
