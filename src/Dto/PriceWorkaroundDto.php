<?php

namespace App\Dto;

use Symfony\Component\ObjectMapper\Attribute\Map;

class PriceWorkaroundDto
{
    public function __construct(
        #[Map(transform: [self::class, 'toBcMath'])]
        public ?\BcMath\Number $priceA = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?\BcMath\Number $priceB = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?\BcMath\Number $priceC = null,

        #[Map(transform: [self::class, 'toBcMath'])]
        public ?\BcMath\Number $priceD = null,
    ) {
    }

    public static function toBcMath(?string $value): ?\BcMath\Number
    {
        return null !== $value && '' !== $value ? new \BcMath\Number($value) : null;
    }
}
