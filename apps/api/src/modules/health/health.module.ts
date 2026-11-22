import { Controller, Get, Module } from "@nestjs/common";
import { ApiOperation, ApiTags } from "@nestjs/swagger";

@ApiTags("health")
@Controller("health")
class HealthController {
  @Get()
  @ApiOperation({ summary: "Verifica disponibilidade da API" })
  getHealth() {
    return { status: "ok" as const };
  }
}

@Module({ controllers: [HealthController] })
export class HealthModule {}
