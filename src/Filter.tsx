interface Props {
  label: string;
  values: string[];
}

const Filter: React.FC<Props> = ({ label, values }) => {
  return (
    <div className="filter">
      <div className="filterLabel">{label}</div>
      <select>
        <option key="na">bez omezení</option>
        {values.map((item, index) => (
          <option key={index} value={item}>
            {item}
          </option>
        ))}
      </select>
    </div>
  );
};

export default Filter;
