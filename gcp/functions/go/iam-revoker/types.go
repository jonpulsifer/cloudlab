package cloudfunction

// Message is the payload of a Pub/Sub event.
// See https://cloud.google.com/functions/docs/calling/pubsub.
type Message struct {
	Data []byte `json:"data"`
}

// LogEntry only cares about the log name and payload
type LogEntry struct {
	LogName  string   `json:"logName"`
	Payload  AuditLog `json:"protoPayload"`
	Resource Resource `json:"resource"`
}

// AuditLog represents the things we care about auditing
type AuditLog struct {
	ServiceName        string             `json:"serviceName"`
	MethodName         string             `json:"methodName"`
	ResourceName       string             `json:"resourceName"`
	AuthenticationInfo AuthenticationInfo `json:"authenticationInfo"`
	AuthorizationInfo  AuthorizationInfo  `json:"authorizationInfo"`
	ServiceData        ServiceData        `json:"serviceData"`
}

// AuthenticationInfo holds the primary email of the user making the request
type AuthenticationInfo struct {
	PrincipalEmail string `json:"principalEmail"`
}

// AuthorizationInfo holds the resource, permission, and whether or not
// the (resource, permission) was granted
type AuthorizationInfo struct {
	Resource   string `json:"resource"`
	Permission string `json:"permission"`
	Granted    bool   `json:"granted"`
}

// ServiceData holds the IAM policy changes
type ServiceData struct {
	Type        string      `json:"@type"`
	PolicyDelta PolicyDelta `json:"policyDelta"`
}

// PolicyDelta holds a list of BindingDeltas
type PolicyDelta struct {
	BindingDeltas []BindingDelta `json:"bindingDeltas"`
}

// BindingDelta holds the action ADD or REMOVE, the member, and the role
type BindingDelta struct {
	Action string `json:"action"`
	Member string `json:"member"`
	Role   string `json:"role"`
}
