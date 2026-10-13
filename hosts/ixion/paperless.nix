{ ... }:

{
  services.paperless = {
    enable = true;
    address = "127.0.0.1";
    port = 28981;
    domain = "paperless.temporalreach.cloud";
    database.createLocally = true;
    consumptionDirIsPublic = true;
    settings = {
      PAPERLESS_OCR_LANGUAGE = "por+eng";
      PAPERLESS_TIME_ZONE = "Europe/Lisbon";
      PAPERLESS_FILENAME_FORMAT = "{{ created_year }}/{{ correspondent }}/{{ title }}";
      PAPERLESS_CONSUMER_IGNORE_PATTERN = [
        ".DS_Store"
        ".DS_STORE/*"
        "desktop.ini"
        "@eaDir/*"
      ];
    };
  };
}
