var crypto = require("crypto");

export const unique = <T>(arr: T[]) => [...new Set(arr)];

export const filterMap = <T, U>(arr: T[], f: (t: T) => U | null) =>
  arr.map(f).filter(notEmpty);

export function notEmpty<T>(value: T | null | undefined): value is T {
  return value !== null && value !== undefined;
}

export function buildSearchUrl(query: string): string {
  const domainConstrainedQuery = `${query} site:ohlasy.info`;
  const queryParams = new URLSearchParams({
    q: domainConstrainedQuery,
    sa: "Hledej",
  });
  return `https://www.google.cz/search?${queryParams}`;
}

/** This is a hack, see https://github.com/vercel/next.js/issues/11993 */
export const filterUndefines = <T>(data: T): T =>
  JSON.parse(JSON.stringify(data));

export function getSignedResizedImage(
  sourceImageUrl: string,
  targetWidth: number,
  signingSecret: string
): string {
  const root = "https://nahledy.ohlasy.info";
  const shasum = crypto.createHash("sha1");
  shasum.update([sourceImageUrl, targetWidth, signingSecret].join(":"));
  const proof = shasum.digest("hex");
  return `${root}/?src=${sourceImageUrl}&width=${targetWidth}&proof=${proof}`;
}
