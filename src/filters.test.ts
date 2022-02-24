import { deserializeSettings, serializeSettings } from "./filters";

test("Serialize settings", () => {
  expect(serializeSettings({ foo: "bar", bar: "baz" })).toBe("foo=bar&bar=baz");
  expect(serializeSettings({ foo: "bar baz" })).toBe("foo=bar%20baz");
});

test("Deserialize settings", () => {
  expect(Object.keys(deserializeSettings(""))).toEqual([]);
  expect(deserializeSettings("#")).toEqual({});
  expect(deserializeSettings("")).toEqual({});
  expect(deserializeSettings("foo=bar%20baz")).toEqual({
    foo: "bar baz",
  });
  expect(deserializeSettings("foo=bar&bar=baz")).toEqual({
    foo: "bar",
    bar: "baz",
  });
});
