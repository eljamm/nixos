{
  lib,
  cacert,
  nixosTests,
  rustPlatform,
  fetchFromGitHub,
}:
rustPlatform.buildRustPackage rec {
  pname = "redlib";
  version = "0.35.1-unstable-2024-11-19";

  src = fetchFromGitHub {
    owner = "redlib-org";
    repo = "redlib";
    rev = "d3ba5f3efb6825f4b0454523dae472b2adda3066";
    hash = "sha256-XT6I7EvSPY2KdKTeJyLQ2tu6iiXipy5PB4OgyEsrMhM=";
  };

  cargoHash = "sha256-AssNRFWB8Nm2v8YKmBINB3+WEUUfd9ra+TRNdJZUB/o=";

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
