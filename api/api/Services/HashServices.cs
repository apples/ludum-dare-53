using HashidsNet;

using Microsoft.Extensions.Options;
using Api.Options;

namespace Api.Services;

public class HashService : IHashService
{
    private readonly Hashids _playerHashids;

    public HashService(IOptions<HashSettings> hashSettingsOptions)
    {
        var hashSettings = hashSettingsOptions.Value;

        _playerHashids = new Hashids(hashSettings.PlayerSalt, hashSettings.PlayerMinLength);
    }

    public string EncodePlayerID(int playerID) =>
        _playerHashids.Encode(playerID);

    public int? DecodePlayerID(string playerHash) =>
        _playerHashids.TryDecodeSingle(playerHash, out var id) ? id: null;
}
