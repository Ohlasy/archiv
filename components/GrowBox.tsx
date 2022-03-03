import { PropsWithChildren, useEffect, useState } from "react";

interface Props<ItemType> {
  items: ItemType[];
  batchSize: number;
  renderItem: (item: ItemType) => JSX.Element;
  loadMoreLabel?: (count: number, batchSize: number) => string;
}

const clamp = (x: number, min: number, max: number) =>
  Math.max(min, Math.min(x, max));

const label = (count: number, batchSize: number) => {
  if (count === 1) {
    return `Zbývající 1 článek`;
  } else if (count >= 2 && count <= 4) {
    return `Zbývající ${count} články`;
  } else if (count < batchSize) {
    return `Zbývajících ${count} článků`;
  } else {
    return `Dalších ${count} článků`;
  }
};

function GrowBox<ItemType>(props: PropsWithChildren<Props<ItemType>>) {
  const { items, batchSize, renderItem, loadMoreLabel = label } = props;
  const [batchNumber, setBatchNumber] = useState(1);
  const batch = items.slice(0, batchNumber * batchSize);

  // Reset when items change
  const loadMore = () => setBatchNumber(batchNumber + 1);
  useEffect(() => {
    setBatchNumber(1);
  }, [items, batchSize]);

  const remainingItemCount = clamp(
    items.length - batchNumber * batchSize,
    0,
    batchSize
  );

  return (
    <>
      <div className="growbox-items">{batch.map(renderItem)}</div>
      {remainingItemCount > 0 && (
        <div className="growbox-controls">
          <a onClick={loadMore}>
            {loadMoreLabel(remainingItemCount, batchSize)}
          </a>
        </div>
      )}
    </>
  );
}

export default GrowBox;
