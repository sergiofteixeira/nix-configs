{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.services.airflow;
in
{
  options.services.airflow = {
    enable = mkEnableOption "Apache Airflow";

    port = mkOption {
      type = types.port;
      default = 8080;
      description = "The port on which Airflow webserver will listen.";
    };

    data_dir = mkOption {
      type = types.path;
      default = "/var/lib/airflow";
      description = ''
        The folder where Airflow data will be stored,\
        e.g. /dags subdirectory";
      '';
    };
  };

  config = mkIf cfg.enable {
    users.groups.airflow = { };
    users.users.airflow = {
      isSystemUser = true;
      home = "${cfg.data_dir}";
      description = "system airflow user";
      group = "airflow";
      shell = pkgs.bash;
      extraGroups = [ "docker" ];
    };

    virtualisation.podman.enable = true;

    systemd.services.airflow = {
      description = "Apache Airflow";
      after = [
        "postgresql.service"
        "podman.service"
      ];
      requires = [
        "postgresql.service"
        "podman.service"
      ];
      path = [ pkgs.coreutils ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        PermissionsStartOnly = true;

        ExecStartPre = [
          # Ensure DAGs folder exists and has proper permissions
          ''${pkgs.coreutils}/bin/mkdir -p ${cfg.data_dir}/dags''
          ''${pkgs.coreutils}/bin/mkdir -p ${cfg.data_dir}/containers''
          ''${pkgs.coreutils}/bin/chown -R airflow:airflow ${cfg.data_dir}''
          ''${pkgs.coreutils}/bin/chmod 755 ${cfg.data_dir}''

          # Remove any existing container named "airflow"
          ''${pkgs.podman}/bin/podman rm -f airflow || true''

          # Initialize the Airflow database
          ''
            ${pkgs.podman}/bin/podman \
            run --rm -v ${cfg.data_dir}/dags:/opt/airflow/dags \
            --network=host \
            --env "AIRFLOW__CORE__LOAD_EXAMPLES=True" \
            --env "AIRFLOW__CORE__EXECUTOR=CeleryExecutor" \
            --env "AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@127.0.0.1:5432/airflow" \
            --env "_AIRFLOW_WWW_USER_CREATE=true" \
            --env "_AIRFLOW_DB_MIGRATE=true" \
            --env "_AIRFLOW_WWW_USER_PASSWORD=admin" \
            --pull=missing apache/airflow:2.10.2 airflow db init
          ''
        ];

        ExecStart = ''
          ${pkgs.podman}/bin/podman run -d --rm --name airflow \
            --network=host \
            -v ${cfg.data_dir}/dags:/opt/airflow/dags \
            -e AIRFLOW__CORE__LOAD_EXAMPLES=True \
            --env "AIRFLOW__WEBSERVER__SECRET_KEY=b4a9ec2ae78d076bbf7310ed5c4388682bc097eab7c5e36c6e7e15c28b893c39" \
            --env "AIRFLOW_WEBSERVER_HOST=airflow" \
            --env "AIRFLOW__CORE__EXECUTOR=CeleryExecutor" \
            --env "AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@127.0.0.1:5432/airflow" \
            --pull=missing \
            apache/airflow:2.10.2 \
            airflow webserver
        '';
        ExecStop = "${pkgs.podman}/bin/podman stop airflow";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    systemd.services.airflow-scheduler = {
      description = "Apache Airflow Scheduler";
      after = [ "airflow.service" ];
      requires = [ "airflow.service" ];
      path = [ pkgs.coreutils ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        PermissionsStartOnly = true;

        ExecStartPre = [
          ''${pkgs.podman}/bin/podman rm -f airflow-scheduler || true''
        ];

        ExecStart = ''
          ${pkgs.podman}/bin/podman run -d --rm --name airflow-scheduler \
          --network=host \
          -v ${cfg.data_dir}/dags:/opt/airflow/dags \
          --env AIRFLOW__CORE__LOAD_EXAMPLES=True \
          --env "AIRFLOW__WEBSERVER__SECRET_KEY=b4a9ec2ae78d076bbf7310ed5c4388682bc097eab7c5e36c6e7e15c28b893c39" \
          --env "AIRFLOW_WEBSERVER_HOST=airflow" \
          --env "AIRFLOW__CORE__EXECUTOR=CeleryExecutor" \
          --env "AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@127.0.0.1:5432/airflow" \
          --env "AIRFLOW__CELERY__BROKER_URL=redis://127.0.0.1:6379/0" \
          --env "AIRFLOW__CELERY__RESULT_BACKEND=redis://127.0.0.1:6379/1" \
          --pull=missing \
          apache/airflow:2.10.2 \
          airflow scheduler
        '';
        ExecStop = "${pkgs.podman}/bin/podman stop airflow-scheduler";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    systemd.services.airflow-worker = {
      description = "Apache Airflow worker";
      after = [ "airflow.service" ];
      requires = [ "airflow.service" ];
      path = [ pkgs.coreutils ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "forking";
        PermissionsStartOnly = true;

        ExecStartPre = [
          ''${pkgs.podman}/bin/podman rm -f airflow-worker || true''
        ];

        ExecStart = ''
          ${pkgs.podman}/bin/podman run -d --rm --name airflow-worker \
          --network=host \
          -v ${cfg.data_dir}/dags:/opt/airflow/dags \
          --env "AIRFLOW__WEBSERVER__SECRET_KEY=b4a9ec2ae78d076bbf7310ed5c4388682bc097eab7c5e36c6e7e15c28b893c39" \
          --env "AIRFLOW__CORE__EXECUTOR=CeleryExecutor" \
          --env "AIRFLOW__CORE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:airflow@127.0.0.1:5432/airflow" \
          --env "AIRFLOW_WEBSERVER_HOST=airflow" \
          --env "AIRFLOW__CELERY__BROKER_URL=redis://127.0.0.1:6379/0" \
          --env "AIRFLOW__CELERY__RESULT_BACKEND=redis://127.0.0.1:6379/1" \
          --pull=missing \
          apache/airflow:2.10.2 \
          airflow celery worker
        '';
        ExecStop = "${pkgs.podman}/bin/podman stop airflow-worker";
        Restart = "on-failure";
        RestartSec = "10s";
      };
    };

    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
