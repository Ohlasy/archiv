import { PropsWithChildren, useEffect, useState } from "react";

interface Props<ItemType> {
  items: ItemType[];
  batchSize: number;
  renderItem: (item: ItemType) => JSX.Element;
}

function GrowBox<ItemType>(props: PropsWithChildren<Props<ItemType>>) {
  const { items, batchSize, renderItem } = props;
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

  const label = remainingItemCount === batchSize ? "Dalších" : "Zbývajících";

  return (
    <>
      <div className="growbox-items">{batch.map(renderItem)}</div>
      {remainingItemCount > 0 && (
        <div className="growbox-controls">
          <a onClick={loadMore}>
            {label} {remainingItemCount} článků
          </a>
        </div>
      )}
    </>
  );
}

const clamp = (x: number, min: number, max: number) =>
  Math.max(min, Math.min(x, max));

export default GrowBox;
