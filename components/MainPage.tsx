import FilterSidebar from "components/FilterSidebar";
import Script from "next/script";
import { Article } from "src/article";
import { FilterOptions, match, Settings } from "src/filters";
import { useEffect, useState } from "react";
import GrowBox from "./GrowBox";

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
      <Header onClick={removeAllFilters} />
      <FilterSidebar
        options={filterOptions}
        settings={settings}
        onChange={updateSettings}
        onSearch={triggerSearch}
        removeAllFilters={removeAllFilters}
      />
      <div className="status">
        nalezených článků: {matchingArticles.length}/{allArticles.length}
      </div>
      <Results articles={matchingArticles} />
    </div>
  );
};

const Header: React.FC<{ onClick: () => void }> = ({ onClick }) => {
  return (
    <div className="header">
      <h1 onClick={onClick}>
        Ohlasy <small>archiv článků</small>
      </h1>
    </div>
  );
};

const Results: React.FC<{ articles: Article[] }> = ({ articles }) => {
  const renderArticle = (article: Article) => (
    <ArticleBox key={article.relativeURL} {...article} />
  );
  return (
    <div className="articles">
      <GrowBox items={articles} renderItem={renderArticle} batchSize={50} />
    </div>
  );
};

const ArticleBox: React.FC<Article> = (article) => {
  const fmtDate = (d: string) =>
    new Date(d).toLocaleDateString("cs-CZ", { dateStyle: "medium" });
  const coverUrl =
    article.coverPhoto ||
    "https://nahledy.ohlasy.info/?src=https://i.ohlasy.info/i/90c5f41a.jpg&width=500&proof=4819733376ba00e5f556f48f7ec1d0ea29c592d8";
  return (
    <a href={"https://ohlasy.info" + article.relativeURL}>
      <div className="article-wrapper">
        <div className="article">
          <div className="cover-photo">
            {/* eslint-disable-next-line */}
            <img src={coverUrl} alt="" />
          </div>
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
