local typedefs = require "kong.db.schema.typedefs"

return {
    name = "keycloak-guard",
    fields = {
        {
            config = {
                type = "record",
                fields = {
                    { KeycloakURL = { type = "string", required = true, description = "The URL of the Keycloak server" } },
                    { Realm = { type = "string", required = true, description = "The Realm for Keycloak server" } },
                    { ClientID = { type = "string", required = true, description = "The client ID for Keycloak" } },
                    { ClientSecret = { type = "string", required = true, description = "The client secret for Keycloak", referenceable = true } },
                    { EnableAuth = { type = "boolean", required = false, default = false, description = "Enable or disable authentication" } },
                    { EnableUMAAuthorization = { type = "boolean", required = false, default = false, description = "Enable or disable simple UMA authorization. This feature will check the provided access token to see if it has the required resource(s)#scope(s). If enabled a set of Permissions and a Strategy has to be provided" } },
                    { EnableRPTAuthorization = { type = "boolean", required = false, default = false, description = "Enable or disable the RPT workflow. resource(s)#scope(s)." } },
                    { Permissions = { type = "array", elements = { type = "string" }, required = false, description = "List of permissions in the format `resourceName#Scope.`" } },
                    { ResourceIDs = { type = "array", elements = { type = "string" }, required = false, description = "List of resource ids." } },
                    { Strategy = { type = "string", required = false, one_of = { "affirmative", "consensus", "unanimous" }, description = "The authorization strategy to use" } },
                },
                entity_checks = {
                    {
                        conditional = {
                            if_field = "EnableUMAAuthorization",
                            if_match = { eq = true },
                            then_field = "Permissions",
                            then_match = { required = true }
                        }
                    },
                    {
                        conditional = {
                            if_field = "EnableUMAAuthorization",
                            if_match = { eq = true },
                            then_field = "Strategy",
                            then_match = { required = true }
                        }
                    },
                    {
                        conditional = {
                            if_field = "EnableUMAAuthorization",
                            if_match = { eq = true },
                            then_field = "EnableAuth",
                            then_match = { required = true }
                        }
                    },
                    {
                        conditional = {
                            if_field = "EnableRPTAuthorization",
                            if_match = { eq = true },
                            then_field = "ResourceIDs",
                            then_match = { required = true }
                        }
                    },
                    {
                        conditional = {
                            if_field = "EnableRPTAuthorization",
                            if_match = { eq = true },
                            then_field = "EnableAuth",
                            then_match = { required = true }
                        }
                    },
                }
            }
        }
    }
}