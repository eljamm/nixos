{ lib, pkgs, ... }:
{
  services.blocky = {
    enable = true;
    settings = {
      port = 53; # Port for incoming DNS Queries.
      upstream.default = [
        "https://one.one.one.one/dns-query" # Using Cloudflare's DNS over HTTPS server for resolving queries.
      ];
      # For initially solving DoH/DoT Requests when no system Resolver is available.
      bootstrapDns = {
        upstream = "https://one.one.one.one/dns-query";
        ips = [
          "1.1.1.1"
          "1.0.0.1"
        ];
      };
      # Enable Blocking of certian domains.
      blocking = {
        blackLists = {
          ads = [
            "https://cdn.jsdelivr.net/gh/hagezi/dns-blocklists@latest/wildcard/pro.txt"
          ];
          adult = [ "https://blocklistproject.github.io/Lists/porn.txt" ];
          annoying = [
            "https://blocklistproject.github.io/Lists/redirect.txt"
            "https://blocklistproject.github.io/Lists/phishing.txt"
            "https://blocklistproject.github.io/Lists/fraud.txt"
          ];
          tracking = [
            "https://blocklistproject.github.io/Lists/tracking.txt"
            # "https://perflyst.github.io/PiHoleBlocklist/android-tracking.txt"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/pihole-google.txt"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/categories/generalparsed"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/categories/firebaseparsed"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/categories/doubleclickparsed"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/categories/analyticsparsed"
            # "https://raw.githubusercontent.com/nickspaargaren/no-google/master/categories/androidparsed"
          ];
        };
        # Configure what block categories are used
        clientGroupsBlock = {
          default = [
            "ads"
            "tracking"
            "annoying"
          ];
          kids-ipad = [
            "ads"
            "tracking"
            "adult"
          ];
        };
      };
      caching = {
        minTime = "5m";
        maxTime = "30m";
        prefetching = true;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}
