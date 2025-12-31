import { expect, test } from "bun:test";

test("Sample test to verify testing setup",
	 () => {
		let x = 3.141;
		expect(x).toBe(x);
	}
);
