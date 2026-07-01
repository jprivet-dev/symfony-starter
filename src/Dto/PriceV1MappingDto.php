<?php

namespace App\Dto;

use BcMath\Number;
use Symfony\Component\ObjectMapper\Attribute\Map;

class PriceV1MappingDto
{
    public function __construct(
        #[Map(transform: [self::class, 'toBcMath'])]
        public ?Number $priceA = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?Number $priceB = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?Number $priceC = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?Number $priceD = null,
    ) {
    }

    public static function toBcMath(?string $value): ?Number
    {
        return null !== $value && '' !== $value ? new Number($value) : null;
    }
}
