import { NextPage, GetStaticProps } from "next";
import { Article } from "src/article";
import { loadAllArticles } from "src/site-data";

interface Props {
  articles: readonly Article[];
}

const Home: NextPage<Props> = ({ articles }) => {
  return <p>Všecko bude! Máme {articles.length} článků.</p>;
};

export const getStaticProps: GetStaticProps<Props> = async () => {
  const articles = await loadAllArticles();
  return {
    props: { articles },
  };
};
export default Home;
