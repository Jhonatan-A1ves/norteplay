import { Test } from "@nestjs/testing";
import { HealthModule } from "./health.module";

describe("HealthModule", () => {
  it("registers the health controller", async () => {
    const module = await Test.createTestingModule({
      imports: [HealthModule],
    }).compile();
    expect(module).toBeDefined();
    await module.close();
  });
});
