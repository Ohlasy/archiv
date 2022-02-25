import FilterSidebar from "components/FilterSidebar";
import Script from "next/script";
import { Article } from "src/article";
import { FilterOptions, match, Settings } from "src/filters";
import { useEffect, useState } from "react";

export interface Props {
  allArticles: Article[];
  filterOptions: FilterOptions;
  initialSettings: Settings;
  onSettingsChange: (settings: Settings) => void;
  triggerSearch: (query: string) => void;
}

const MainPage: React.FC<Props> = (props) => {
  const { allArticles, filterOptions, initialSettings } = props;
  const { onSettingsChange, triggerSearch } = props;

  const [settings, setSettings] = useState(initialSettings);
  const [matchingArticles, setMatchingArticles] = useState(allArticles);

  // Load fresh initial settings when props change
  useEffect(() => {
    setSettings(initialSettings);
  }, [initialSettings]);

  // Filter articles when settings change
  useEffect(() => {
    const matches = allArticles.filter((a) => match(a, settings));
    setMatchingArticles(matches);
  }, [settings, allArticles]);

  // Update settings based on events from the sidebar
  const updateSettings = (id: string, newValue: string | undefined) => {
    if (newValue) {
      const newSettings = { ...settings, [id]: newValue };
      setSettings(newSettings);
      onSettingsChange(newSettings);
    } else {
      const { [id]: _, ...newSettings } = settings;
      setSettings(newSettings);
      onSettingsChange(newSettings);
    }
  };

  const removeAllFilters = () => {
    setSettings({});
    onSettingsChange({});
  };

  return (
    <div>
      <Script
        data-domain="archiv.ohlasy.info"
        src="https://plausible.io/js/plausible.js"
      />
      <Header />
      <div className="status">
        nalezených článků: {matchingArticles.length}/{allArticles.length}
      </div>
      <FilterSidebar
        options={filterOptions}
        settings={settings}
        onChange={updateSettings}
        onSearch={triggerSearch}
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

export default MainPage;
