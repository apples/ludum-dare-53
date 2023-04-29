using System.Text;

namespace Api.Test.Extensions;

internal static class RandomExtensions
{
    public static string GenerateRandomString(this Random random, int length, params Range[] characterRanges)
    {
        if (length <= 0)
        {
            throw new ArgumentException("Length must be greater than 0.");
        }

        var characters = new List<char>();

        foreach (var range in characterRanges)
        {
            if (range.Start.IsFromEnd || range.End.IsFromEnd)
            {
                throw new ArgumentException($"Range {range} cannot use FromEnd.");
            }

            if (range.Start.Value > range.End.Value)
            {
                throw new ArgumentException($"Range {range} has Start greater than End.");
            }

            for (int i = range.Start.Value; i <= range.End.Value; i++)
            {
                characters.Add((char)i);
            }
        }

        var stringBuilder = new StringBuilder(length);
        for (int i = 0; i < length; i++)
        {
            stringBuilder.Append(characters[random.Next(characters.Count)]);
        }

        return stringBuilder.ToString();
    }
}
