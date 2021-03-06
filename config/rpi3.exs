use Mix.Config

config :nerves_firmware_ssh,
  authorized_keys: [File.read!(Path.join(System.user_home!(), ".ssh/mx.pub"))]

config :logger, backends: [RingLogger]

config :nerves_init_gadget,
  ifname: "wlan0",
  address_method: :dhcp,
  node_host: :mdns_domain,
  ssh_console_port: 22,
  node_name: "nac"

[ssid, psk] = File.read!(".wlan_settings") |> String.split()

config :nerves_network, regulatory_domain: "US"

config :nerves_network, :default,
  wlan0: [
    ssid: ssid,
    psk: psk,
    key_mgmt: :"WPA-PSK"
  ],
  eth0: [ipv4_address_method: :dhcp]

case Mix.env do
  :dev ->
    config :nac, :gpio_to_zone_mapping, [
      %{zone: 1, gpio: 16},
      %{zone: 2, gpio: 20},
      %{zone: 3, gpio: 21}
    ]

    config :nerves_init_gadget,
      mdns_domain: System.get_env("MDNS_DOMAIN") || "nacd-rpi3.local"


  :prod ->
    config :nac, :gpio_to_zone_mapping, [
      %{zone: 1, gpio: 26},
      %{zone: 2, gpio: 19},
      %{zone: 3, gpio: 13},
      %{zone: 4, gpio: 6}
    ]

    config :nerves_init_gadget,
      mdns_domain: "nac.local"
end
