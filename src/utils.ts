export const unique = <T>(arr: T[]) => [...new Set(arr)];

export const filterMap = <T, U>(arr: T[], f: (t: T) => U | null) =>
  arr.map(f).filter(notEmpty);

export function notEmpty<T>(value: T | null | undefined): value is T {
  return value !== null && value !== undefined;
}
