import { expect, test } from "bun:test";

test("Sample test to verify testing setup",
	 () => {
		const x = 3.141;
		expect(x).toBe(x);
	}
);
