import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { FilterOptions, getFilterOptions } from "src/filters";
import { loadAllArticles } from "src/site-data";
import Filter from "src/Filter";

interface Props {
  articles: readonly Article[];
  filterOptions: FilterOptions;
}

const Home: NextPage<Props> = (props) => {
  return (
    <div>
      <Header />
      <Stats {...props} />
      <Sidebar {...props} />
      <Results {...props} />
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

const Stats: React.FC<Props> = ({ articles }) => {
  return <div className="status">nalezených článků: {articles.length}</div>;
};

const Sidebar: React.FC<Props> = ({ filterOptions: options }) => {
  return (
    <div className="sidebar">
      <div className="filters">
        <Filter label="Autor" values={options.authors} />
        <Filter label="Rubrika" values={options.categories} />
        <Filter label="Seriál" values={options.serials} />
        <Filter label="Téma" values={options.topics} />
        <Filter label="Rok" values={options.years} />
      </div>
    </div>
  );
};

const Results: React.FC<Props> = ({ articles }) => {
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
