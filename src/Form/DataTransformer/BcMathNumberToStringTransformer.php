<?php

namespace App\Form\DataTransformer;

use BcMath\Number;
use Symfony\Component\Form\DataTransformerInterface;
use Symfony\Component\Form\Exception\TransformationFailedException;

class BcMathNumberToStringTransformer implements DataTransformerInterface
{
    public function __construct(
        private ?int $scale = null,
    ) {
    }

    public function transform(mixed $value): string
    {
        if (null === $value) {
            return '';
        }

        if (!$value instanceof Number) {
            throw new TransformationFailedException('Expected a BcMath\Number.');
        }

        return (string) $value;
    }

    public function reverseTransform(mixed $value): ?Number
    {
        if (null === $value || '' === $value) {
            return null;
        }

        if (!is_numeric($value)) {
            throw new TransformationFailedException(\sprintf('"%s" is not a valid number.', $value));
        }

        $number = new Number($value);

        if (null !== $this->scale) {
            $number = $number->round($this->scale);
        }

        return $number;
    }
}
