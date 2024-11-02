{
  lib,
  stdenv,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
  darwin,
}:
rustPlatform.buildRustPackage rec {
  pname = "redlib";
  version = "0.35.1-unstable-2024-11-01";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "2fd358f3eda1c25992c2a1c2d0e1bef2506627cb";
    hash = "sha256-NAvl6HyJAMsc46gTlROJxAE2Co/NkkSBT9QH8/GF72k=";
  };

  cargoHash = "sha256-PNqecQSx0Q+K3bBfbOJYWPdl7JdUTDQ4f95RUuW0vPw=";

  buildInputs = lib.optionals stdenv.isDarwin [
    darwin.apple_sdk.frameworks.Security
  ];

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
