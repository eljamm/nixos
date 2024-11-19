{
  lib,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "redlib";
  version = "0.35.1-unstable-2024-11-15";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "6c64ebd56b98f5616c2014e2e0567fa37791844c";
    hash = "sha256-QXcjpIO1y6mi+4E2BC6O16TaLFfpcPcCHumuJBXmcoU=";
  };

  cargoHash = "sha256-tb+qTANios+dvNK775gqy0AmB5fuj5BhfYYYegnraEg=";

  checkFlags = [
    # All these test try to connect to Reddit.
    "--skip=test_fetching_subreddit_quarantined"
    "--skip=test_fetching_nsfw_subreddit"
    "--skip=test_fetching_ws"

    "--skip=test_gated_and_quarantined"

    "--skip=test_obfuscated_share_link"
    "--skip=test_share_link_strip_json"

    "--skip=test_localization_popular"
    "--skip=test_fetching_subreddit"
    "--skip=test_fetching_user"

    # These try to connect to the oauth client
    "--skip=test_oauth_client"
    "--skip=test_oauth_client_refresh"
    "--skip=test_oauth_token_exists"

    "--skip=test_oauth_headers_len"
    "--skip=test_banned_sub"
    "--skip=test_gated_sub"
    "--skip=test_private_sub"
  ];

  env = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
  };

  passthru.tests = {
    inherit (nixosTests) redlib;
  };

  meta = {
    changelog = "https://github.com/redlib-org/redlib/releases/tag/v${version}";
    description = "Private front-end for Reddit (Continued fork of Libreddit)";
    homepage = "https://github.com/redlib-org/redlib";
    license = lib.licenses.agpl3Only;
    mainProgram = "redlib";
    maintainers = with lib.maintainers; [ soispha ];
  };
}
