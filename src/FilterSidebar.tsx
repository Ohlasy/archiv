import { ChangeEvent } from "react";
import { Filter, FilterOptions, filters } from "./filters";

interface Props {
  options: FilterOptions;
  onChange: (id: string, value: string | undefined) => void;
}

const FilterSidebar: React.FC<Props> = ({ options, onChange }) => {
  return (
    <div className="sidebar">
      <div className="filters">
        {filters.map((filter) => (
          <Filter
            key={filter.id}
            filter={filter}
            values={options[filter.id]}
            onChange={(value) => onChange(filter.id, value)}
          />
        ))}
      </div>
    </div>
  );
};

interface FilterProps {
  filter: Filter;
  values: string[];
  onChange: (value: string | undefined) => void;
}

const Filter: React.FC<FilterProps> = ({ filter, values, onChange }) => {
  const emptyLabel = "bez omezení";
  const handleChange = (event: ChangeEvent<HTMLSelectElement>) => {
    const value = event.target.value;
    const reportedValue = value === emptyLabel ? undefined : value;
    onChange(reportedValue);
  };
  const identity = (a: string) => a;
  const dressValue = filter.displayValue || identity;
  return (
    <div className="filter">
      <div className="filterLabel">{filter.name}</div>
      <select onChange={handleChange}>
        <option key="na">{emptyLabel}</option>
        {values.map((item, index) => (
          <option key={index} value={item}>
            {dressValue(item)}
          </option>
        ))}
      </select>
    </div>
  );
};

export default FilterSidebar;
