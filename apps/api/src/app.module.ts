import { Module } from "@nestjs/common";
import { AuditLogsModule } from "./modules/audit-logs/audit-logs.module";
import { AuthModule } from "./modules/auth/auth.module";
import { DemosModule } from "./modules/demos/demos.module";
import { HealthModule } from "./modules/health/health.module";
import { MatchesModule } from "./modules/matches/matches.module";
import { MixModule } from "./modules/mix/mix.module";
import { NotificationsModule } from "./modules/notifications/notifications.module";
import { PermissionsModule } from "./modules/permissions/permissions.module";
import { PlayersModule } from "./modules/players/players.module";
import { RolesModule } from "./modules/roles/roles.module";
import { ServerAgentModule } from "./modules/server-agent/server-agent.module";
import { ServerCommandsModule } from "./modules/server-commands/server-commands.module";
import { ServerProfilesModule } from "./modules/server-profiles/server-profiles.module";
import { ServersModule } from "./modules/servers/servers.module";
import { StatisticsModule } from "./modules/statistics/statistics.module";
import { TeamsModule } from "./modules/teams/teams.module";
import { UsersModule } from "./modules/users/users.module";

@Module({
  imports: [
    AuthModule,
    UsersModule,
    RolesModule,
    PermissionsModule,
    ServersModule,
    ServerProfilesModule,
    ServerAgentModule,
    ServerCommandsModule,
    PlayersModule,
    TeamsModule,
    MatchesModule,
    MixModule,
    StatisticsModule,
    DemosModule,
    NotificationsModule,
    AuditLogsModule,
    HealthModule,
  ],
})
export class AppModule {}
