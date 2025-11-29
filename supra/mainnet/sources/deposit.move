module supra_addr::deposit {

    use std::string::String;
    use std::vector;

    /// Capability struct for VRF module permissions
    struct SupraVRFPermit<phantom T> has store {}

    /// Client's module balance information return struct
    struct ClientModuleInfo has drop, copy {
        module_type_info: String,
        max_callback_txn_fee: u64,
        min_balance_limit: u64,
        balance: u64,
        enabled: bool,
        current_grant: u64
    }

    /// Client fund information return struct (Necesaria para get_balance_of_client_v2)
    struct ClientFundInfo has drop, copy {
        client_address: address,
        min_balance_limit: u64,
        balance: u64,
        current_grant: u64,
        max_txn_fee: u64
    }

    // ============================================================================
    // View Functions (Entry)
    // ============================================================================

    /// Reinitialize the module to migrate (Admin)
    native public entry fun reinitialize_module(owner: &signer, min_request_count: u64, default_supra_grant: u64);

    /// Migrate object ownership to multisig account (Admin)
    native public entry fun migrate_to_multisig(owner_signer: &signer, multisig_address: address);

    /// Set minimum balance limit in supra coins (Admin)
    native public entry fun set_min_balance_limit_supra(sender: &signer, min_balance_limit_supra: u64);

    /// Set cold wallet address for fund collection (Admin)
    native public entry fun set_cold_wallet(sender: &signer, new_supra_multisig_vrf: address);

    /// Set default supra grant amount provided to new clients (Admin)
    native public entry fun set_default_supra_amount(sender: &signer, default_grant: u64);

    /// Set minimum request count used for balance limit calculations (Admin)
    native public entry fun set_min_request_count(sender: &signer, min_request_count: u64);

    /// Enable or disable the contract V1 (Admin)
    native public entry fun set_contract_disabling(sender: &signer, pause: bool);

    /// Enable or disable the contract V2 (Admin)
    native public entry fun set_contract_disabling_v2(sender: &signer, pause: bool);

    /// Claim free node expenses from supra_fund (Admin)
    native public entry fun claim_free_node_expenses_v2(sender: &signer, amount: u64);

    /// Increase the grant amount for a whitelisted client (Admin)
    native entry fun increase_client_grant(admin: &signer, client_address: address, amount: u64);

    /// Disable all modules for a client (Admin)
    native public entry fun disable_all_client_modules(sender: &signer, client_address: address);

    // ============================================================================
    // Funciones de Cliente (Entry & Public)
    // ============================================================================

    /// Whitelist a client address with specified configuration
    native public entry fun whitelist_client_address(client: &signer, max_txn_fee: u64);

    /// Initialize VRF module for a client
    native public fun init_vrf_module<T>(client: &signer): SupraVRFPermit<T>;

    /// Enable a module for VRF requests
    native public entry fun enable_module<T>(client: &signer);

    /// Disable a module from making VRF requests
    native public entry fun disable_module<T>(client: &signer);

    /// Remove a module from client's whitelist
    native public fun remove_module<T>(permit_cap: SupraVRFPermit<T>);

    /// Update maximum transaction fee for all modules of a client
    native entry public fun update_max_txn_fee(user: &signer, max_txn_fee: u64);

    /// Update maximum callback transaction fee for a specific module
    native public entry fun update_max_callback_txn_fee<T>(client: &signer, max_callback_txn_fee: u64);

    /// Deposit funds for V1 client
    native public entry fun deposit_fund(sender: &signer, deposit_amount: u64);

    /// Deposit funds for V2 client
    native public entry fun deposit_fund_v2(sender: &signer, client_address: address, deposit_amount: u64);

    /// Client withdrawing deposit Supra coin
    native public entry fun withdraw_fund(sender: &signer, withdraw_amount: u64);

    // ============================================================================
    // Funciones de Lectura (View)
    // ============================================================================

    #[view]
    /// Get the object address for deposit management
    native public fun get_deposit_management_object_address(): address;

    #[view]
    /// Get the object address for balance management
    native public fun get_balance_object_address(): address;

    #[view]
    /// Check if a module is enabled for VRF requests
    native public fun is_module_enabled<T>(): bool;

    #[view]
    /// Check if the VRF functionality is paused
    native public fun is_contract_paused(): bool;

    #[view]
    /// Get the minimum request count for balance calculations
    native public fun min_request_count(): u64;

    #[view]
    /// Get the default supra grant amount
    native public fun default_supra_grant(): u64;

    #[view]
    /// Check if client is whitelisted (V2)
    native public fun is_client_whitelisted_v2(client_address: address): bool;

    #[view]
    /// Check if client has reached minimum balance threshold (V2)
    native public fun has_minimum_balance_reached_v2(client_address: address): bool;

    #[view]
    /// Get client's current balance
    native public fun check_client_fund(client_address: address): u64;

    #[view]
    /// Get client's remaining grant amount
    native public fun get_client_remaining_grant(client_address: address): u64;

    #[view]
    /// Get total grant amount allocated to client
    native public fun get_client_total_grant(client_address: address): u64;

    #[view]
    /// Get supra's minimum balance limit (V2)
    native public fun check_min_balance_supra_v2(): u64;

    #[view]
    /// Get client's minimum balance requirement (V2)
    native public fun check_min_balance_client_v2(client_address: address): u64;

    #[view]
    /// Get client's maximum transaction fee (V2)
    native public fun check_max_txn_fee_client_v2(client_address: address): u64;

    #[view]
    /// Get client's effective balance (balance - min_balance) for V2
    native public fun check_effective_balance_v2(client_address: address): u64;

    #[view]
    /// Get balance and grant information for multiple clients (V2)
    native public fun get_balance_of_client_v2(addresses: vector<address>): vector<ClientFundInfo>;

    #[view]
    /// Get detailed information for a specific module
    native public fun get_module_info<T>(): ClientModuleInfo;

    #[view]
    /// Get information for all modules whitelisted by a client
    native public fun get_client_modules_info(client_address: address): vector<ClientModuleInfo>;
}
