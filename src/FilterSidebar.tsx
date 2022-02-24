import { ChangeEvent } from "react";
import { Filter, FilterOptions, filters } from "./filters";

interface Props {
  options: FilterOptions;
  settings: Record<string, string>;
  onChange: (id: string, value: string | undefined) => void;
  removeAllFilters: () => void;
}

const FilterSidebar: React.FC<Props> = ({
  options,
  settings,
  onChange,
  removeAllFilters,
}) => {
  return (
    <div className="sidebar">
      <div className="filters">
        {filters.map((filter) => (
          <Filter
            key={filter.id}
            filter={filter}
            values={options[filter.id]}
            selected={settings[filter.id]}
            onChange={(value) => onChange(filter.id, value)}
          />
        ))}
        <button
          onClick={removeAllFilters}
          disabled={Object.keys(settings).length === 0}
        >
          Smazat filtry
        </button>
      </div>
    </div>
  );
};

interface FilterProps {
  filter: Filter;
  values: string[];
  selected: string | undefined;
  onChange: (value: string | undefined) => void;
}

const Filter: React.FC<FilterProps> = (props) => {
  const emptyLabel = "bez omezení";
  const { filter, values, selected, onChange } = props;
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
      <select onChange={handleChange} value={selected ?? emptyLabel}>
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
