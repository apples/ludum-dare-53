namespace Api.Options;

public sealed class HashSettings
{
    public const string Position = "HashSettings";

    public string PlayerSalt { get; set; } = default!;

    public int PlayerMinLength { get; set; }
}
