DELETE FROM xdp_profile_crypto_policies WHERE profile_id IN (SELECT id FROM xdp_profiles WHERE config_id = 30);
DELETE FROM xdp_profile_traffic_rules   WHERE profile_id IN (SELECT id FROM xdp_profiles WHERE config_id = 30);
DELETE FROM xdp_profile_locals          WHERE profile_id IN (SELECT id FROM xdp_profiles WHERE config_id = 30);
DELETE FROM xdp_profile_wans            WHERE profile_id IN (SELECT id FROM xdp_profiles WHERE config_id = 30);
DELETE FROM xdp_profiles                WHERE config_id = 30;

DELETE FROM xdp_local_configs WHERE config_id = 30;
DELETE FROM xdp_wan_configs   WHERE config_id = 30;
DELETE FROM xdp_redirect_rules WHERE config_id = 30;
DELETE FROM xdp_configs       WHERE id = 30;

INSERT INTO xdp_configs (id) VALUES (30);

INSERT INTO xdp_local_configs (config_id, ifname, network) VALUES
(30, 'enp7s0', '192.168.9.0/24');

INSERT INTO xdp_wan_configs (config_id, ifname, dst_ip) VALUES
(30, 'enp6s0', '192.168.203.2/24');

INSERT INTO xdp_profiles (
    config_id,
    profile_name,
    enabled,
    channel_bonding,
    description
) VALUES
(30, 'wan_enp6s0_single', 1, 1, 'WAN group enp6s0 (single), supports multiple source/destination pairs');

INSERT INTO xdp_profile_locals (profile_id, ifname)
SELECT p.id, 'enp7s0'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_wans (profile_id, ifname, bandwidth_weight_percent)
SELECT p.id, 'enp6s0', 100
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_redirect_rules (config_id, src_cidr, dst_cidr) VALUES
(30, '192.168.9.0/24', '192.168.182.0/24');

INSERT INTO xdp_profile_traffic_rules (profile_id, src_cidr, dst_cidr)
SELECT p.id, '192.168.9.0/24', '192.168.182.0/24'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    201, p.id, 100, 'bypass', 'UDP',
    'Any', 'Any', 'Any', '5201',
    'gcm', 128, 16, NULL
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    202, p.id, 110, 'encrypt_l2', 'UDP',
    'Any', 'Any', 'Any', '5202',
    'gcm', 128, 16, '2b7e151628aed2a6abf7158809cf4f3c'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    203, p.id, 120, 'encrypt_l3', 'UDP',
    'Any', 'Any', 'Any', '5203',
    'gcm', 128, 16, '5b95b6540e1785f1797661e2413becd5'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    204, p.id, 130, 'encrypt_l4', 'UDP',
    'Any', 'Any', 'Any', '5204',
    'ctr', 128, 16, '00112233445566778899aabbccddeeff'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    209, p.id, 140, 'bypass', 'UDP',
    '192.168.9.10', 'Any', '192.168.182.20', '5301',
    'gcm', 128, 16, NULL
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    210, p.id, 150, 'encrypt_l2', 'UDP',
    '192.168.9.11', 'Any', '192.168.182.0/24', '5302',
    'gcm', 128, 16, '2b7e151628aed2a6abf7158809cf4f3c'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    211, p.id, 160, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.33', '5303',
    'gcm', 128, 16, '5b95b6540e1785f1797661e2413becd5'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    212, p.id, 170, 'encrypt_l4', 'UDP',
    '!192.168.9.0/24', 'Any', '192.168.182.44', '5304',
    'ctr', 128, 16, '00112233445566778899aabbccddeeff'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    213, p.id, 180, 'encrypt_l3', 'TCP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '5401',
    'gcm', 128, 16, '5b95b6540e1785f1797661e2413becd5'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    214, p.id, 190, 'encrypt_l4', 'TCP',
    '!192.168.9.50', 'Any', 'Any', '5402',
    'ctr', 128, 16, '00112233445566778899aabbccddeeff'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    215, p.id, 200, 'bypass', 'ICMP',
    'Any', 'Any', 'Any', 'Any',
    'gcm', 128, 16, NULL
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    216, p.id, 210, 'encrypt_l2', 'ANY',
    '!192.168.9.20', 'Any', '!192.168.182.99', 'Any',
    'gcm', 128, 16, '2b7e151628aed2a6abf7158809cf4f3c'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    225, p.id, 220, 'encrypt_l3', 'UDP',
    '192.168.2.1', 'Any', '192.168.0.0/24,10.2.4.0/12,192.168.182.2', '5501',
    'gcm', 128, 16, '5b95b6540e1785f1797661e2413becd5'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

-- === Priority / overlap lab (forward 192.168.9.x -> 192.168.182.x) ===
-- A: UDP dst 6005 — two rules match; priority 40 beats 120 (lower number wins). Expect wire/db id 230 + key aaaa...
INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    230, p.id, 40, 'encrypt_l3', 'UDP',
    '192.168.9.20/32', 'Any', '192.168.182.20/32', '6005',
    'gcm', 128, 12, 'aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    231, p.id, 120, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6005',
    'gcm', 128, 12, 'bbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

-- B: UDP dst 6006 — same priority 88, same match; tie-break lower db id (232) wins over 233
INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    232, p.id, 88, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6006',
    'gcm', 128, 12, 'cccccccccccccccccccccccccccccccc'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    233, p.id, 88, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6006',
    'gcm', 128, 12, 'dddddddddddddddddddddddddddddddd'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

-- C: UDP dst 6007 — ANY with best priority (10) loses to UDP-specific in pass-0; expect id 235 for UDP.
--    Non-UDP (e.g. proto 47) with no specific rule falls through to pass-1; expect id 234.
INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    234, p.id, 10, 'encrypt_l3', 'ANY',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6007',
    'gcm', 128, 12, 'eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    235, p.id, 200, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6007',
    'gcm', 128, 12, 'ffffffffffffffffffffffffffffffff'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

-- D: UDP dst 6009 — bypass (prio 15) vs encrypt_l3 (prio 45); same 5-tuple; expect bypass wins
INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    236, p.id, 15, 'bypass', 'UDP',
    '192.168.9.40/32', 'Any', '192.168.182.40/32', '6009',
    'gcm', 128, 12, NULL
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';

INSERT INTO xdp_profile_crypto_policies (
    id, profile_id, priority, action, protocol,
    src_cidr, src_port, dst_cidr, dst_port,
    crypto_mode, aes_bits, nonce_size, crypto_key
)
SELECT
    237, p.id, 45, 'encrypt_l3', 'UDP',
    '192.168.9.0/24', 'Any', '192.168.182.0/24', '6009',
    'gcm', 128, 12, '0123456789abcdef0123456789abcdef'
FROM xdp_profiles p
WHERE p.config_id = 30 AND p.profile_name = 'wan_enp6s0_single';