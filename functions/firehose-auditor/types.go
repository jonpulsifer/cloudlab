package p

type PubSubMessage struct {
	Data []byte `json:"data"`
}

// https://cloud.google.com/logging/docs/reference/audit/auditlog/rest/Shared.Types/AuditLog
type AuditLog struct {
	LogName      string        `json:"logName"`
	ID           string        `json:"insertId"`
	Service      string        `json:"serviceName"`
	ProtoPayload *ProtoPayload `json:"protoPayload"`
}

type ProtoPayload struct {
	LogType            string               `json:"@type"`
	AuthenticationInfo *AuthenticationInfo  `json:"authenticationInfo"`
	AuthorizationInfo  []*AuthorizationInfo `json:"authorizationInfo,omitempty"`
	Method             string               `json:"methodName"`
}

type AuthenticationInfo struct {
	Email string `json:"principalEmail"`
}

type AuthorizationInfo struct {
	Granted    bool   `json:"granted"`
	Permission string `json:"permission"`
	Resource   string `json:"resource"`
}
